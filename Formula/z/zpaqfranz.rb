class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https:github.comfcorbellizpaqfranz"
  url "https:github.comfcorbellizpaqfranzarchiverefstags59.4.tar.gz"
  sha256 "556b30d9c29d26f2705d862155aaf351c8801c2423288c9b397fd76f461ac84d"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https:github.comfcorbellizpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57a9c65acb911d522705227fe03bd5b15ca6dd3b0002cdfb2ef368ff4e840497"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0037830461011b7edead1d648e7e63181fa7f57bc12afc40dbaac293860790e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57cc8cf3963d9c4109a23f98e631914f4a55355d1015501cbd766330034b4849"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ed9719e3f6db5e4a5ff6e44b182d87e1a1580b32835c2d3761c707b87fcfd55"
    sha256 cellar: :any_skip_relocation, ventura:        "db8e525154a5431b4b6f16541d877ddeffb5dba4d195edcfab5489b60634730d"
    sha256 cellar: :any_skip_relocation, monterey:       "2d87129c4401c57c93f9b6b12098fb8cfbe7efe4d8debb96a1d32c837d23a476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b835c77c64427c7957427d7b0ff620946d76dc0c9d912e1d2d87492d6f15af30"
  end

  def install
    bin.mkdir

    # JIT only works on Intel (might work on Linux aarch64, but not Apple Silicon)
    ENV.append_to_cflags "-DNOJIT" unless Hardware::CPU.intel?

    system "make", "install", "-f", "NONWINDOWSMakefile", "BINDIR=#{bin}#{name}"
    man1.install Utils::Gzip.compress("manzpaqfranz.1")
  end

  test do
    system bin"zpaqfranz", "autotest", "-to", testpath"archive"
    system bin"zpaqfranz", "extract", testpath"archivesha256.zpaq", "-to", testpath"out"
    testpath.glob("out*").each do |path|
      assert_equal path.basename.to_s.downcase, Digest::SHA256.hexdigest(path.read)
    end
  end
end