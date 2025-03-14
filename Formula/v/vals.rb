class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https:github.comhelmfilevals"
  url "https:github.comhelmfilevalsarchiverefstagsv0.39.4.tar.gz"
  sha256 "36e4bd0295b4f7f015e8f1fbbedbdb9fd0ad4a2be698df4b9152b249c96b0fee"
  license "Apache-2.0"
  head "https:github.comhelmfilevals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a782a1cf9c6b93ed594939ce26c34904e30bc8ab3ba94f20b828451273810f69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a782a1cf9c6b93ed594939ce26c34904e30bc8ab3ba94f20b828451273810f69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a782a1cf9c6b93ed594939ce26c34904e30bc8ab3ba94f20b828451273810f69"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6f0028eb4796f3a5b84cb59f4e562d82f4a0cd415b4ad547648c903f73fdf45"
    sha256 cellar: :any_skip_relocation, ventura:       "a6f0028eb4796f3a5b84cb59f4e562d82f4a0cd415b4ad547648c903f73fdf45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5903471660a7c1a148c535a590b19d60465b3fb2eabbab5e6faede9552e0607c"
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