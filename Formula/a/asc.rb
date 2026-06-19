class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/2.1.1.tar.gz"
  sha256 "1bfd3618b3ecb2c38502cfe907e2666b103401f133893ea3becc4882b102a2d7"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a35e7e9c9984f905662bd52d434fc87479b898b84b177c79f60fe25ba9b87409"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f646cd50b75df76b112e9f11005cd9b19ab31c25f896340fa075e8012c14460"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2619e0b3ff235acc1e116387849bbec9062025997ffe8aded968e1181cc6f5cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba62ea89735c646d69468d841dfd73f75accf641bb88349beab92a16105ff17c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b59330c0d353997fa59b73d6b99642eb7c3d2e330745df2b3615ae06f3b2c198"
    sha256 cellar: :any,                 x86_64_linux:  "9a07e2780022b8f17f4756b400e1059e577055f85d817e3daa8090fbb6db4cd5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end