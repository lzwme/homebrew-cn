class Cdecl < Formula
  desc "Turn English phrases to C or C++ declarations"
  homepage "https:github.compaul-j-lucascdecl"
  url "https:github.compaul-j-lucascdeclreleasesdownloadcdecl-18.4.1cdecl-18.4.1.tar.gz"
  sha256 "5b7899fb44b30e67a0375223368a7b342c2047ffa9f268b90f7c6eaa9db2a474"
  license all_of: [
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later", # gnulib
    :public_domain, # original cdecl
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "363c05b8547ead28209b9d14ed12e7765359ae4e5a2d28b18ef4b488400950b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d56b56d1c525678f844e3dd83e89dbca5e4d8db5ad57daf11ea08d1bfc9453c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98a53d5cd3b85690103a4901e59296ee3a6f8fa94aaa2702e42e29c6267b9ffc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a6be79e61b3bbf3ed748d8df383ae50bf4b33978484a79f876b9e176d577ef7"
    sha256 cellar: :any_skip_relocation, ventura:       "9971729c1580ea4e25bc41e60830397586c19181ba073adb5579a264ef022072"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3393652d469f42d4bc1b998275ba05d60b88975366d30bea5a6d2ebe761da8e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ced2523c93fde88e64b437a8db68c5f28d60353dafa872258fd290280897592a"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "readline"
  end

  def install
    system ".configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "declare a as pointer to integer",
                 shell_output("#{bin}cdecl explain int *a").strip
  end
end