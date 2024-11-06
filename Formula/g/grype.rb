class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.84.0.tar.gz"
  sha256 "d93b200053588e3b03b133bd36d8e39e80c053d31baa0c326b8bb90928667e27"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1deee0b237878d536af5cec89228c816359ffcb6938f5f7f9b9e5e9134a7795d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fd27d74f427139a68f4ae6fefa9764bfd89c5b2b975bc7de303cb2ba41bd396"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76e42a51d2b2e5b5b0422b543a967ac4b24072c78ec29dcb159c8bbda68f60ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "f503f10149808489f08c6b1dd809073f36f7849d945d03dd6e63befcb66e3642"
    sha256 cellar: :any_skip_relocation, ventura:       "b4fad834e238caca983d388efa5fe87d1af64213d869146d2a24e0f1ad207ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01877f475641ff986b42c5e29fdd2b814024bacb5cd93c719b52538851ab6ba6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end