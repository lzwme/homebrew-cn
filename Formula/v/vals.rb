class Vals < Formula
  desc "Helm-like configuration values loader with support for various sources"
  homepage "https:github.comhelmfilevals"
  url "https:github.comhelmfilevalsarchiverefstagsv0.41.2.tar.gz"
  sha256 "548c18a04900cc4c822a0c6e2a7b668d01648a1e59d7df7d4d5177200f0aec88"
  license "Apache-2.0"
  head "https:github.comhelmfilevals.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c77be8b0dbf5ad00c84b0f61b68442ab9b68a301ea9e0a4563d2867db7f5f611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c77be8b0dbf5ad00c84b0f61b68442ab9b68a301ea9e0a4563d2867db7f5f611"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c77be8b0dbf5ad00c84b0f61b68442ab9b68a301ea9e0a4563d2867db7f5f611"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1e12277a84d0402aacd8e3673fa3439d423f11d25c0426ef198d7df146d89c1"
    sha256 cellar: :any_skip_relocation, ventura:       "a1e12277a84d0402aacd8e3673fa3439d423f11d25c0426ef198d7df146d89c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a72f947e253e8c04a3c9781d4d91e21ccdddb640ba720dacd7c72307af1e47a4"
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