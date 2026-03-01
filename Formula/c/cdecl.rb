class Cdecl < Formula
  desc "Turn English phrases to C or C++ declarations"
  homepage "https://github.com/paul-j-lucas/cdecl"
  url "https://ghfast.top/https://github.com/paul-j-lucas/cdecl/releases/download/cdecl-18.7/cdecl-18.7.tar.gz"
  sha256 "f7a061b2255713eb9d3aa71bfdff89c09c60057cfc0b8e97e846e0ad85ebc874"
  license all_of: [
    "GPL-3.0-or-later",
    "LGPL-2.1-or-later", # gnulib
    :public_domain, # original cdecl
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7268ec3dd3cd52e0e92256b41f80130f235452533d32bac80bef24ab3845ab07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cd900927cbb125be0572d9fd8ca84e66046d6ecb978dd895de6e107786aa018"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1c0858ac9eb08e5fb2b9eeb34612234e5b0bf48e907e7b403fdc17e0c4ad66e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec012dde3765308f16359d3403c9c4c9d3b39fa5bb73a3d4ad0ee3d1e2984101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f349dbcf111ddf478dce0ec97a5ab15f740d702c533fdeddcdd99112069cff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b2df8e012cca06199ccb05427b08c9fb68a5eeae53ee9e7a4f6afe3d4c82f96"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "declare a as pointer to integer",
                 shell_output("#{bin}/cdecl explain int *a").strip
  end
end