class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.10.8.tar.gz"
  sha256 "632bbd8427f48e150024aee69fb605ac952cc288ccbeed465bbaea8f68037c9c"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a45dd1524e2b1bcb9eaba5152c092493a49269856de5dc73d62ca3d8cbfd3a85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a45dd1524e2b1bcb9eaba5152c092493a49269856de5dc73d62ca3d8cbfd3a85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a45dd1524e2b1bcb9eaba5152c092493a49269856de5dc73d62ca3d8cbfd3a85"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bd1c1e6b120fb24f5c464bd5ae1df249545c83c7a760caf59ce2efdcb802b1d"
    sha256 cellar: :any_skip_relocation, ventura:       "7bd1c1e6b120fb24f5c464bd5ae1df249545c83c7a760caf59ce2efdcb802b1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f319bee2a2643124991e6f8740ad42510e4993e6e472e351ded43bca6fc30e90"
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