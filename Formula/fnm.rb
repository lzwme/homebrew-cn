class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https:github.comSchnizfnm"
  url "https:github.comSchnizfnmreleasesdownloadv1.38.1fnm-macos.zip"
  sha256 "80deb3db3db45598f25aea594c10936a7658f70826104fe37e33b4072a5e11f9"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  def install
    bin.install "fnm"
    generate_completions_from_executable(bin"fnm", "completions", "--shell")
  end

  test do
    system bin"fnm", "install", "19.0.1"
    assert_match "v19.0.1", shell_output("#{bin}fnm exec --using=19.0.1 -- node --version")
  end
end