class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https:carapace.sh"
  url "https:github.comcarapace-shcarapace-binarchiverefstagsv1.0.7.tar.gz"
  sha256 "bfcd950178023909b0854bc6bded5b57d1c00123943e9dbcdfddf2a632c71ff4"
  license "MIT"
  head "https:github.comcarapace-shcarapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d93d4450d53a2b5b4b45fb9f836040326d7d7c4d1ec3652c6634cc416a5bc284"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d93d4450d53a2b5b4b45fb9f836040326d7d7c4d1ec3652c6634cc416a5bc284"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d93d4450d53a2b5b4b45fb9f836040326d7d7c4d1ec3652c6634cc416a5bc284"
    sha256 cellar: :any_skip_relocation, sonoma:        "d74a0fecbc1466a9ea760a11557aadea948e218e4344ab167e8d4cc33275864b"
    sha256 cellar: :any_skip_relocation, ventura:       "d74a0fecbc1466a9ea760a11557aadea948e218e4344ab167e8d4cc33275864b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b7f67f9a595bd2efcac13e3a63c36d8ebd8ff81ba27aa44e3a0785b04838a79"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "...."
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "release", ".cmdcarapace"
  end

  test do
    system bin"carapace", "--list"
    system bin"carapace", "--macro", "color.HexColors"
  end
end