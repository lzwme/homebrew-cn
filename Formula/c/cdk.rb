class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20251001.tgz"
  sha256 "18b196e601a65533d0dff32626fbb887514d8688e783d7f6098b4b4ebc64d853"
  license "BSD-4-Clause-UC"

  livecheck do
    url "https://invisible-mirror.net/archives/cdk/"
    regex(/href=.*?cdk[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fee06e0178ead00b6cbee3d62147276eeb0382699a80dd53f7a20f8dbb12ea86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d75434eba5167bda69a6b92e6715d7c6c888139c0453f82678fd8671a9bfa1b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98d0c2e6426c7ce8079920a8f92c40b33b7085c19fd4c52c0f5952b2683a8113"
    sha256 cellar: :any_skip_relocation, sonoma:        "972f6f7663d8bb862277cd8a2396c07a6a70db668d35f0933d342fc33e2d72bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f18f3b47a9e5a49873e9f8ce889a05891a8aa4395057cc45a7eaf493827330fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecd24b4910ec9afe92504dca0a091e3f25e4ed515b67b4fcf0e9d8caa026adc3"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end