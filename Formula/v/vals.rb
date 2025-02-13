class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https:github.comhelmfilevals"
  url "https:github.comhelmfilevalsarchiverefstagsv0.39.1.tar.gz"
  sha256 "4bd8d630100b8d5dc27b0e86d7b543f8b000b936dba5c4d06b8dfbe7f96239dc"
  license "Apache-2.0"
  head "https:github.comhelmfilevals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "599bec763daa69f8b2f552805a3586081cf3a0bd92843e2efcd584a5f95fbb6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "599bec763daa69f8b2f552805a3586081cf3a0bd92843e2efcd584a5f95fbb6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "599bec763daa69f8b2f552805a3586081cf3a0bd92843e2efcd584a5f95fbb6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f2ac293b278d5c05b8fbcd2b01471be59a9ab0a99bf038aaf7f5b311787a424"
    sha256 cellar: :any_skip_relocation, ventura:       "0f2ac293b278d5c05b8fbcd2b01471be59a9ab0a99bf038aaf7f5b311787a424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b318e04b972c5cd5c6dff1ccce1760dcef40ef053d0300d0eb792384262d230"
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