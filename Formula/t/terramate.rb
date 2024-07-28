class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.9.4.tar.gz"
  sha256 "827bcf0ae974237a2ca6c99e4a7fbe7395110312ab3ff92d33be78cac39b958b"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "294de82873517b482620aac1c1018ebe99be176bdf97bec40575767a2d173cac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e611b7f72fb918fc6112368beb714fad32615955e835572e5666a62eaf2d9a95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e057531a83fce15d4bfba50b3b880cbdc1ceb9a040e72a6841321b3d322a64f"
    sha256 cellar: :any_skip_relocation, sonoma:         "33e2a94a839e897368f279274f3fc27cad49bd16ed671952cedb6f4f80d330ea"
    sha256 cellar: :any_skip_relocation, ventura:        "7dbf518b77b637f185522c4ddf5896ee53358f8a4d7bb41ee51f9efefaea6cbd"
    sha256 cellar: :any_skip_relocation, monterey:       "b4a1da0651c6295b1799f6bff2132044e5801ee48830846aff2992534b005377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1485e64063f3d8b845fd210e1ed6499b97f8a09f968f2d4dc120bd9d2c34b6a4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end