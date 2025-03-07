class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.42.0.tgz"
  sha256 "fd9ae71b9c00bf0f673c40112b9be012a0862288f179526e04377455f9fe5b33"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8d03b75a8dbf44029618f10e5babb7f0750581610a7c78040451cd686f75ddf3"
    sha256 cellar: :any,                 arm64_sonoma:  "8d03b75a8dbf44029618f10e5babb7f0750581610a7c78040451cd686f75ddf3"
    sha256 cellar: :any,                 arm64_ventura: "8d03b75a8dbf44029618f10e5babb7f0750581610a7c78040451cd686f75ddf3"
    sha256 cellar: :any,                 sonoma:        "57982e725005fd3eeeb7472b0729385f09b24fd5a1ff10e1aec16319c326a0f5"
    sha256 cellar: :any,                 ventura:       "57982e725005fd3eeeb7472b0729385f09b24fd5a1ff10e1aec16319c326a0f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1714e756f04b7aa581b58e509c3897d989e2430b8ce7130f70ab3a42e390dd64"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end