class Fatsort < Formula
  desc "Sorts FAT16 and FAT32 partitions"
  homepage "https://fatsort.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fatsort/fatsort-1.6.6.660.tar.xz"
  version "1.6.6"
  sha256 "9b1fb35451e2b5cec4ca02f0693aa4e7bb1b52e305014719bdf4fa586a44e0e9"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/fatsort[._-]v?(\d+(?:\.\d+)+)\.\d+\.t}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee91ba0f011ade57860fec48d9b7a161b1713bf31ff6d681b16d30c9d758164c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3e1cfcb3c1fa725cda98283293a797c869d021a9d46796bc571060029aed10c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebf4ac4a1e3b7d0ead6fac9733d7aae34ac675e5eda648a3fecc6fa566b76926"
    sha256 cellar: :any_skip_relocation, sonoma:        "552cf897b24ae8fa803ecfb4859138f168c556fb58437c54144f2e2f71398459"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48c9728d079d8606ebd4968c77ac44257d507ea7e48b1f502fc32b5a93cd8d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cf1ec9d7602857ac81f0ffce04e678c9079d3bb023570a0e525fc646aeac6f7"
  end

  depends_on "help2man"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "src/fatsort"
    man1.install "man/fatsort.1"
  end

  test do
    system bin/"fatsort", "--version"
  end
end