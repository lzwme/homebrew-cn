class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https:github.comfcorbellizpaqfranz"
  url "https:github.comfcorbellizpaqfranzarchiverefstags60.9.tar.gz"
  sha256 "e55633e3f186a5e1618d294df7505975523e98e706a282118614679ed9dc19c8"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https:github.comfcorbellizpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0542f69dbeb3156e5bfb571b9b7ac6a06333f6f7a531c9d721ff2033dab14d64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02933d1096705d9d416f389f1924e2cc3ea42ba012867e84fb8fd525d8c9f682"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a66481260a4fa0cf22de001ee0df296f1d103ad482caa355d912fef7e1064982"
    sha256 cellar: :any_skip_relocation, sonoma:        "45c1bfb5bf8c19ac647be33ac5f614865cc0e3fecac38f68ef4b6bc584ec25da"
    sha256 cellar: :any_skip_relocation, ventura:       "155fdfe4349d26d32513b733a61a9c3c3fcea7641d329f90f1f7ff93fdda1f75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f975d30f30d96172e20bc8ab1986b091b08287daaaef6dc87866fbac665515a"
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