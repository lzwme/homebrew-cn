class Zpaqfranz < Formula
  desc "Deduplicating command-line archiver and backup tool"
  homepage "https:github.comfcorbellizpaqfranz"
  url "https:github.comfcorbellizpaqfranzarchiverefstags59.5.tar.gz"
  sha256 "dae0eff01b872f0f58084d2f94e3546e875230e1fbed88efaa819a5c1792543f"
  license all_of: [:public_domain, "MIT", "Zlib", "Unlicense", "BSD-2-Clause", "Apache-2.0"]
  head "https:github.comfcorbellizpaqfranz.git", branch: "main"

  # Some versions using a stable tag format are marked as pre-release on GitHub,
  # so it's necessary to check release versions instead of tags.
  livecheck do
    url :url
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "baa719add64f112bf60f9eda3b7431824828aa3b8ca5d57feeaee14f267128f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7990439109987595002ba0205163107defdd7b5c6aa8b1e6b96d237562e6bdf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbaecbb7050f78e7556171a52df905be42a5d956d2881ca5b2d7ef53c0c79e1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dc79c3faf9115d438e65f98a7b6ea939c6b6dedbdab4982abb4defec89d3153"
    sha256 cellar: :any_skip_relocation, ventura:        "7beedada8cf60bc60015af451b5bf51369d3626b06616dd1081b4d9fd0b7ad14"
    sha256 cellar: :any_skip_relocation, monterey:       "72fc73262caa6d9b34757cba233ab65408f592f6a9a900c6a617dd9c90fecf6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17c1ccc9c75ebff2ece2f3b72dc0d8ebbea9fb8803c2130e28b597d753d02081"
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