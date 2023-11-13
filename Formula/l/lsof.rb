class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://github.com/lsof-org/lsof"
  url "https://ghproxy.com/https://github.com/lsof-org/lsof/archive/refs/tags/4.99.0.tar.gz"
  sha256 "27fca13b6a3682114a489205a89d05d92f1c755e282be1f3590db15b16b2ed06"
  license "lsof"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a283d7620cf6abbf47985a4303eacd1b802f176762afdc9e5dcc3d157ab4eb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ac764fc32b8ae7e66cbfa60d55d66e75d5ab6c92b95a63499a2dee8d5aeab06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b99f7fea72c46c93f3a78be27181f77c13672be9ee4220a070a7da0caaf12ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebc72026b680c2419acbabbb5d87563852af08604192b9d171466960ad4ad518"
    sha256 cellar: :any_skip_relocation, ventura:        "562132d5ba00c3cf726c4f3c45f478201dd9c436815bf83945a5905c0e45bce7"
    sha256 cellar: :any_skip_relocation, monterey:       "7a90ccc7f96bf216cdc4701310338e57714b631e37057ee2061f8ef3d4fc85ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b86358f2141c7a4edf4ce28af7abec22985e429a8463e842fc02a43b99e834d"
  end

  keg_only :provided_by_macos

  on_linux do
    depends_on "libtirpc"

    # fix argument mismatch for gethostnm
    # upstream PR ref, https://github.com/lsof-org/lsof/pull/298
    patch do
      url "https://github.com/lsof-org/lsof/commit/5aebb5fd63372ddf6cb3fdc84b3b6afe67e738f2.patch?full_index=1"
      sha256 "3878a9360cb426a1c2b3902beb585017d2991fd1e498f770a59a8aa6eb0e6cf3"
    end
  end

  def install
    if OS.mac?
      ENV["LSOF_INCLUDE"] = MacOS.sdk_path/"usr/include"

      # Source hardcodes full header paths at /usr/include
      inreplace "lib/dialects/darwin/machine.h", "/usr/include", MacOS.sdk_path/"usr/include"
    else
      ENV["LSOF_INCLUDE"] = HOMEBREW_PREFIX/"include"
    end

    ENV["LSOF_CC"] = ENV.cc
    ENV["LSOF_CCV"] = ENV.cxx

    mv "00README", "README"
    system "./Configure", "-n", OS.kernel_name.downcase

    system "make"
    bin.install "lsof"
    man8.install "Lsof.8"
  end

  test do
    (testpath/"test").open("w") do
      system "#{bin}/lsof", testpath/"test"
    end
  end
end