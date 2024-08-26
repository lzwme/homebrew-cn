class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https:github.comfcorbellizpaqfranz"
  url "https:github.comfcorbellizpaqfranzarchiverefstags60.6.tar.gz"
  sha256 "08593f5fd0b7120f42942aebf02f674ac4ff6539dce6b62414fc0472e49df06f"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https:github.comfcorbellizpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "094dfff4b5d621440463fd95e163577f483c68b41d72d5ac295623bba1ca4e45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49473890245a57ce33804ef33bf7cb4d09dbb6dc278bebca43d11efd90424e49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc0191f5774d38d9ff996eb76590af75a7ee00262bbd016310b67914444eb447"
    sha256 cellar: :any_skip_relocation, sonoma:         "accf7423d5ae8d510cb28e135731213b23bf08da78567481e425d3c090f20349"
    sha256 cellar: :any_skip_relocation, ventura:        "80598cd30779072dafd859bcdbdc88f977823930245d65d9a05352284099a1ce"
    sha256 cellar: :any_skip_relocation, monterey:       "33679897804e2b1b9d85aa524edb06faba5118e9fc5a59235a0e37d86776d8b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "500f0610116d0ebdf25bccbd5b44125c7f5f2503bd1735d3856ffba91fc705d1"
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