class Simg2img < Formula
  desc "Tool to convert Android sparse images to raw images and back"
  homepage "https:github.comanestisbandroid-simg2img"
  url "https:github.comanestisbandroid-simg2imgarchiverefstags1.1.4.tar.gz"
  sha256 "cbd32490c1e29d9025601b81089b5aec1707cb62020dfcecd8747af4fde6fecd"
  license "Apache-2.0"
  head "https:github.comanestisbandroid-simg2img.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b25e0f06cde868bdec04ba4dd906433abb120d7748f165880eef898bed510ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29690971daf156fb520ac5fae0f14f758b7b9e904488ad949af13806931eb1e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f06e180e9b83dbc722ee3539e038c69b556d366ebb425b4bb2bb6c849b3d129b"
    sha256 cellar: :any_skip_relocation, sonoma:        "70b91d0825fd80872068fa97fedd0e6d3144837187843805b9d568345b9fb3b0"
    sha256 cellar: :any_skip_relocation, ventura:       "b6bc8f731b9624d8ffaaf482be2809afb81d2bb088c91769b880202b9ef53799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da000263e52d0f4c11a13e4674e2eed694bb6348ebd0be1a4d3240478825e15b"
  end

  uses_from_macos "zlib"

  # Fix execution on apple silicon from a fork
  patch do
    url "https:github.comanestisbandroid-simg2imgcommit931df9dd83e7feea11197402c5b4e7ad489f4abf.patch?full_index=1"
    sha256 "97f7e1256e9bc0fcfb4e1714ac503c7d5a4901a1685fe86307222d0f67ae5898"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "dd", "if=devzero", "of=512k-zeros.img", "bs=512", "count=1024"
    assert_equal 524288, (testpath"512k-zeros.img").size?,
                 "Could not create 512k-zeros.img with 512KiB of zeros"
    system bin"img2simg", "512k-zeros.img", "512k-zeros.simg"
    assert_equal 44, (testpath"512k-zeros.simg").size?,
                 "Converting 512KiB of zeros did not result in a 44 byte simg"
    system bin"simg2img", "512k-zeros.simg", "new-512k-zeros.img"
    assert_equal 524288, (testpath"new-512k-zeros.img").size?,
                 "Converting a 44 byte simg did not result in 512KiB"
    system "diff", "512k-zeros.img", "new-512k-zeros.img"
  end
end