class Rack < Formula
  desc "CLI for Rackspace"
  homepage "https:github.comrackspacerack"
  url "https:github.comrackspacerack.git",
      tag:      "1.2",
      revision: "09c14b061f4a115c8f1ff07ae6be96d9b11e08df"
  license "Apache-2.0"
  head "https:github.comrackspacerack.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ca055d57a0b7118129720698989f6f43dc536772699f03a5706f4c47702b22c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0759cf2ff2e0d842496eb25f1f485532d9aa42ef1f62d1c4210ea4a4fdace3d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d81bffa7fcd9b0e5079359935e35b155a3e0a970b0526b50928c084522fcdc79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3da24ffbc52e301b97902eee71ecddbbb16c6df508a9241a4a9ed2dc7eed0652"
    sha256 cellar: :any_skip_relocation, sonoma:         "0041c553e0e8920b0f377fdb0cc42636efeba068c63605ff82cb95b790261d97"
    sha256 cellar: :any_skip_relocation, ventura:        "9899299df120a54af4b9137076d412649bcb8bde210fb7a60b49552fbe9e7528"
    sha256 cellar: :any_skip_relocation, monterey:       "5f0280df3a5a8ea3e28533d43434ce2d97e0ba3ff35f74f1b3041008f594b820"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f5f2eac4a06a9295875d213a31505f9b8e66e96b16814176582e3fd5a0a223e"
    sha256 cellar: :any_skip_relocation, catalina:       "8cf224e3f734308bef6c0ef3cd9aa3a63aa4fdedd9ee626e2ee91099affc83c2"
    sha256 cellar: :any_skip_relocation, mojave:         "a50004c910fc4cbb34404fabf20bfcab87dcf6d7ce510a96c72fecbdc8d458cc"
    sha256 cellar: :any_skip_relocation, high_sierra:    "5e33e2bc51e9cf346ed59eabbef5849a170619be2a7b034b19d71a1a25a72fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88a7a29b2c8fc2f04d5009bb498e2a424aaf2c246a55915c2f0d7b12f7accfec"
  end

  # https:github.comrackspacerackpull470
  disable! date: "2024-02-24", because: :unmaintained

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TRAVIS_TAG"] = version
    ENV["GO111MODULE"] = "auto"

    rackpath = buildpath"srcgithub.comrackspacerack"
    rackpath.install Dir["{*,.??*}"]

    cd rackpath do
      # This is a slightly grim hack to handle the weird logic around
      # deciding whether to add a = or not on the ldflags, as mandated
      # by Go 1.7+.
      # https:github.comrackspacerackissues446
      inreplace "scriptbuild", "go1.5", Utils.safe_popen_read("go", "version")[go1\.\d]

      ln_s "internal", "vendor"
      system "scriptbuild", "rack"
      bin.install "rack"
    end
  end

  test do
    system bin"rack"
  end
end