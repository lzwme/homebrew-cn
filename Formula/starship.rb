class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://ghproxy.com/https://github.com/starship/starship/archive/v1.14.1.tar.gz"
  sha256 "cd70aece33ccb393c6030e3852c677c8e6b8292a635264a0a8d7f0222eca0087"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b42dcceeddaf6cd557d2dbeba4a0b5bdbc8d0fc2cc846a8d9852a3d6d73ee78f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2580e2a6dc2fa518e8295eceee90d8945d9d501dff16523485c9712db4c23c0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53fea38af784b1532b867504c0394f21bad57c277d2606db9b74bedaa0f5c65b"
    sha256 cellar: :any_skip_relocation, ventura:        "da67f64a0dc08f0af7f475ee89a7cc37c77c0ff7e52e31ccf376138ad768442a"
    sha256 cellar: :any_skip_relocation, monterey:       "84b0399ba82433eaba4c7d6a09013bf60f32002222f7b3530ff2e97e16e66441"
    sha256 cellar: :any_skip_relocation, big_sur:        "22e5334dddfbb668adfc3ba09be7d2f28376d3f93619d990a7340ab96110f9a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a88e7647121854a8d63e90f7a796aa247c06d24d3cb5d3108ba0b17463243b75"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"starship", "completions")
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end