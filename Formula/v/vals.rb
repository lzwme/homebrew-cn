class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https:github.comhelmfilevals"
  url "https:github.comhelmfilevalsarchiverefstagsv0.39.3.tar.gz"
  sha256 "da79854866e730d0bc099173804768a417bae7ca95240750106e56cde804e7b9"
  license "Apache-2.0"
  head "https:github.comhelmfilevals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a95412ceee5715e22d9da48585209e65fe48f7d6a343d48cf7c247c9182d034"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a95412ceee5715e22d9da48585209e65fe48f7d6a343d48cf7c247c9182d034"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a95412ceee5715e22d9da48585209e65fe48f7d6a343d48cf7c247c9182d034"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9989c2ef827fa28a5e9053918e39fe9c531b02e73b177aa5719b10d1ce39c03"
    sha256 cellar: :any_skip_relocation, ventura:       "b9989c2ef827fa28a5e9053918e39fe9c531b02e73b177aa5719b10d1ce39c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7baea7986a4af2fcd768014804c66ab9040f6b216d268469c79c2bfbb987fc57"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"), ".cmdvals"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vals version")

    (testpath"test.yaml").write <<~YAML
      foo: "bar"
    YAML
    output = shell_output("#{bin}vals eval -f test.yaml")
    assert_match "foo: bar", output

    (testpath"secret.yaml").write <<~YAML
      apiVersion: v1
      kind: Secret
      metadata:
        name: test-secret
      data:
        username: dGVzdC11c2Vy # base64 encoded "test-user"
        password: dGVzdC1wYXNz # base64 encoded "test-pass"
    YAML

    output = shell_output("#{bin}vals ksdecode -f secret.yaml")
    assert_match "stringData", output
    assert_match "username: test-user", output
    assert_match "password: test-pass", output
  end
end