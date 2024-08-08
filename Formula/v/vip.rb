class Vip < Formula
  desc "Program that provides for interactive editing in a pipeline"
  homepage "https:www.cs.duke.edu~desvip.html"
  url "https:www.cs.duke.edu~desscriptsvip"
  version "19971113"
  sha256 "171278e8bd43abdbd3a4c35addda27a0d3c74fc784dbe60e4783d317ac249d11"
  # Permission is granted to reproduce and distribute this program
  # with the following conditions:
  #   1) This copyright notice and the author identification below
  #      must be left intact in the program and in any copies.
  #   2) Any modifications to the program must be clearly identified
  #      in the source file.
  #
  # Written by Daniel E. Singer, Duke Univ. Dept of Computer Science, 53095
  license :cannot_represent

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b14079339dd70f264f10a81fc1d4934353ab7aa85b32403de04703ba5340dc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd1eaee76c43cbe5384907f794d619db9b4d044eb54e223e0666e4da73f007e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd1eaee76c43cbe5384907f794d619db9b4d044eb54e223e0666e4da73f007e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd1eaee76c43cbe5384907f794d619db9b4d044eb54e223e0666e4da73f007e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b14079339dd70f264f10a81fc1d4934353ab7aa85b32403de04703ba5340dc6"
    sha256 cellar: :any_skip_relocation, ventura:        "cd1eaee76c43cbe5384907f794d619db9b4d044eb54e223e0666e4da73f007e8"
    sha256 cellar: :any_skip_relocation, monterey:       "cd1eaee76c43cbe5384907f794d619db9b4d044eb54e223e0666e4da73f007e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd1eaee76c43cbe5384907f794d619db9b4d044eb54e223e0666e4da73f007e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e859ab68e89bde9988f3966d5b5352ccb56dc0d88ddd958d200b5f60e5f91653"
  end

  resource "man" do
    url "https:www.cs.duke.edu~desscriptsvip.man"
    sha256 "37b2753f7c7b39c81f97b10ea3f8e2dd5ea92ea8d130144fa99ed54306565f6f"
  end

  # use awk and vartmp as temporary directory
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches85fa66a9vip19971113.patch"
    sha256 "96879c8d778f21b21aa27eb138424a82ffa8e8192b8cf15b2c4a5794908ef790"
  end

  def install
    bin.install "vip"
    resource("man").stage do
      man1.install "vip.man" => "vip.1"
    end
  end
end