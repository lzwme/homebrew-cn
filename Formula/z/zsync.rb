class Zsync < Formula
  desc "File transfer program"
  homepage "https://zsync.moria.org.uk/"
  url "https://zsync.moria.org.uk/download/zsync-0.7.0.tar.gz"
  sha256 "ff2c154c400a8893b332f9f87b45b7300e5b2071f0e54b69da8c692b58fd86b1"
  license "Artistic-2.0"
  head "https://github.com/cph6/zsync.git", branch: "master"

  livecheck do
    url "https://zsync.moria.org.uk/downloads"
    regex(/href=.*?zsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12e96b41f0c2cca218d488016b5f113d9ca3eb9dde85d13dfbd1d07634671c74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12e96b41f0c2cca218d488016b5f113d9ca3eb9dde85d13dfbd1d07634671c74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12e96b41f0c2cca218d488016b5f113d9ca3eb9dde85d13dfbd1d07634671c74"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d03856c3009453e1913140f378bc93e8a0aa56d7ba72aba27fc4a3709eff5c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e9e2f4ce10ce50733c4f7329d80d052efa0898eda3f32c9d15237bcddedf702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42557ff05556fd843218746a1a1f129f72c44c9d67b72c2aa4f69ba64e118280"
  end

  depends_on "go" => :build

  def install
    (buildpath/"cmd").each_child(false) do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/cmd), "./cmd/#{cmd}"
      man1.install "man/#{cmd}.1"
    end
  end

  test do
    touch testpath/"foo"
    system bin/"zsyncmake", "foo"
    sha1 = "da39a3ee5e6b4b0d3255bfef95601890afd80709"
    assert_match "SHA-1: #{sha1}", (testpath/"foo.zsync").read
  end
end