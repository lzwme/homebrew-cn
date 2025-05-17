class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https:github.comcondarattler"
  url "https:github.comcondarattlerarchiverefstagsrattler_index-v0.22.7.tar.gz"
  sha256 "34aabfc58d72adb4fbc5a51bd110e03ba1c1b383eba1c30334fee56f09b18d1a"
  license "BSD-3-Clause"
  head "https:github.comcondarattler.git", branch: "main"

  livecheck do
    url :stable
    regex(^rattler_index-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b6633e8ab50eeec3668d60fe3be9d8a37f48202bbd99ec548f107ef90692dbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40f0ee8d0ee799ac97c543bb624ad49a05bc3b334c4305677462ed5a6e5a26ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bfce8caa584037c5604c16a57eba5ec3326334ba60781be131da4f01f795554"
    sha256 cellar: :any_skip_relocation, sonoma:        "d140abb87cfd07a2c8d28168d8950a5895020711aaad06e2fbf7a0daf4a016af"
    sha256 cellar: :any_skip_relocation, ventura:       "23519c81deab28850986fd9f163ddb6babe1f69c3000bcf47ee1dab617e50373"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e929be46c87c8cddb5aa707acdba17b1675e4e9b1c463ccffe6a6472d5749b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f90ebf3376ed830a4001df32ede0d06fad859fe921ba0419d05598905afa5f18"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls", "--no-default-features",
        *std_cargo_args(path: "cratesrattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}rattler-index --version").strip

    system bin"rattler-index", "fs", "."
    assert_path_exists testpath"noarchrepodata.json"
  end
end