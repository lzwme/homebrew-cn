class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://ghfast.top/https://github.com/robertpsoane/ducker/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "f3f7a2a6479dc63ba60e44d0bcaeac9dc7efe5fa27c957ede2bc04b650f628cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4d95da3943e4a5026ea30e06d863b20565f0f8b7ce4748bc2ba8344478325d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7b83cc1b8fa0b5155db9dc72d769f7a4087ff3ef29b31c306d219dd7c48044c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e5bacbeac9eb05cebd203fbc98897bf3ffef1c11b211845f2fc9ce6a5f95725"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7ef4cd4f34ad553ff66fd9c75f5b90cb700c7ec836204bb91079e97999481e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baca2c3bf5ea0cc6eb748023ef7fff33aec5669fed7ae5fab0f6a64fe6efcc0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78dc64dd88cefe9fd4f2f58775729b2f3a1dc86f1381b8a17bd0e9a30be54731"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ducker", "--export-default-config"
    assert_match "prompt", (testpath/".config/ducker/config.yaml").read

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end