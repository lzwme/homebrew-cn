class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://ghfast.top/https://github.com/robertpsoane/ducker/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "91106c1249000339012ba3916ba5b499478a68ef72819dff295454340cd89b72"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4cab4b53b4a9abbefef9823eea4564dcb8fbc34ea24f5544c497f226a31fecf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c2c39e83ad7df61ffe9b600f150a54a4a40a8c2761b09e1b575e1c822b93152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a409267956b4f8f92b7e4ae0a15114467d51b11e07a754f25a22a7889e8f08b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1415266515ef3402a33ffc407079aa7fb4053975822362d31a5e3b214b8e286"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a3d01854dc827fcab3f2f3bb9ab88739ed528465564183222fa48efe170e2f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b39525b39ab7554115af9622a1972b577ca3f450e76ffc8302274d1b6ffdbdc"
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