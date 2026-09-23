class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://ghfast.top/https://github.com/bmf-san/ggc/archive/refs/tags/v8.7.4.tar.gz"
  sha256 "1ff5dd7cedc765f92bcc72f57bbeb5f77ab62daf9020e514ab87998994351059"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e424c81404f1f223700b2f163c006ca4197714b49893e7e77b7df55b33a8d8b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4e424c81404f1f223700b2f163c006ca4197714b49893e7e77b7df55b33a8d8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4e424c81404f1f223700b2f163c006ca4197714b49893e7e77b7df55b33a8d8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "21f71ab667f313622361ebc0b57bf5ea6d2635bdcd9900284b059af14c950379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f0ded1f4c6b9b46f46489407e849dbd5c2290848aac2a1aa4694ee735c01f624"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end