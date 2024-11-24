class Nerdfix < Formula
  desc "Findfix obsolete Nerd Font icons"
  homepage "https:github.comloichyannerdfix"
  url "https:github.comloichyannerdfixarchiverefstagsv0.4.2.tar.gz"
  sha256 "e56f648db6bfa9a08d4b2adbf3862362ff66010f32c80dc076c0c674b36efd3c"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5e050b3eb4e291e14f25b6abb1bbafce0b627e4c9161b4061cc622b011492ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c08fe804ef44f8bb8d254817ef6c7ffbe4900d0653a77509a5a10338d5d8142b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eadf88c586ec7c4911fe67650fce7aac1b78d9149be4e5d60c146014a528caaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "57dad8812389ebb6707876de647ffb4275a77c7e486e0945571d6096e96ad4d9"
    sha256 cellar: :any_skip_relocation, ventura:       "a37f03017360965083c43e046918c264f121f435ff5c141d087660b82965e059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e921666ec8ea11f6d2874a2980d27840ce8b86659cbe5b580c6cdd408fff35a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.txt"
    system bin"nerdfix", "check", "test.txt"
  end
end