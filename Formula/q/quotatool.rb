class Quotatool < Formula
  desc "Edit disk quotas from the command-line"
  homepage "https:quotatool.ekenberg.se"
  url "https:github.comekenbergquotatool.git",
    tag:      "v1.6.5",
    revision: "62180fb1cc7d5d4e90cbbb578cba6bcc967c7ca8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73fe8aa2a02124cafcf9abdac863eba005e9eb1ab81d8e135cd33f6eb2d40685"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5a43288144374c56357b8086915aaca5eba18e53f0940837d4cf298e70d07e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9eecb97ad263acbc09900928486b0fe14a1b87e4e8bdff42c86bcc1ca3d8c8bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "b978f4cf5786ea8301c04df5c0ca7454c18532af3dda7b6ebc873ef05a57113a"
    sha256 cellar: :any_skip_relocation, ventura:        "aa6e214389d5b093d52adacca8254ed4938d2b22f00e49df43b7cae204eebeef"
    sha256 cellar: :any_skip_relocation, monterey:       "2ef1c105633c850e2f2ecff526621787052f683e6aa463c8b8be85c50ea3d6dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c0feda58df20431481105e54c7cdc01e78168423035c50cbcf813c096dc5121"
  end

  on_macos do
    depends_on "coreutils" => :build # make install uses `-D` flag
  end

  def install
    system ".configure", "--prefix=#{prefix}"
    sbin.mkpath
    man8.mkpath
    system "make", "install"
  end

  test do
    system "#{sbin}quotatool", "-V"
  end
end