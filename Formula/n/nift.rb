class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://ghfast.top/https://github.com/nift-dev/nift/archive/refs/tags/v4.0.7.tar.gz"
  sha256 "412be30dfc0666298b32a1a1b980dff10c138cd585c5fa6fdbba7c2ddb1e90a5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a81e085e59e9923b1a01a4484c8586636fb40ea537a33fcbc9842c19842e040"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f68162853f80c3e5f4e36e223895989b982e4891ca0d284e6cee1311b1dde69e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c542e7b761bbc2605b194b9f7f63b15a99805bebcdc5dd96119d28062be1b45c"
    sha256 cellar: :any,                 arm64_linux:   "a7dc65f6c02cd57c9d9d5f4ee487b4004bd9cbcd23fb6883222e9a7350f11c4c"
    sha256 cellar: :any,                 x86_64_linux:  "18b747fd5afa6b3bb7f13d408bbd5ecc865aea6a06396bf54d85442a8b30f88a"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nift", "init", "--ext=.html"
    assert_path_exists testpath/"public/index.html"
  end
end