class Decasify < Formula
  desc "Utility for casting strings to title-case according to locale-aware style guides"
  homepage "https:github.comalerquedecasify"
  url "https:github.comalerquedecasifyreleasesdownloadv0.9.1decasify-0.9.1.tar.zst"
  sha256 "c486b545229f0401693c79d600aa3e38bafdac70cd8c40c44f506c377b742a93"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "201ec2162c0785af3408ff3b1fd5dea5ace9ef47d5d161ee2fd61f71d636f751"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ddf5299581f0714d50c387715a04596c3ecdd580d1777162baeafd735640d20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a2752af8048e52388ff82ab208ef428db1bed9717d6915da338512a3e267a61"
    sha256 cellar: :any_skip_relocation, sonoma:        "91bac4b9e1137df31b82455d6969e2a0a27443144fa96e045b12e5ba797fbf47"
    sha256 cellar: :any_skip_relocation, ventura:       "4715b1a045b481936cd403fd5be3e47fb8018a5b91eaf254fed20acabf3d84c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b411294a5ede09d29a53d8b215d8a099f079381c72d6f2eaede2293bb29164ac"
  end

  head do
    url "https:github.comalerquedecasify.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jq" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system ".bootstrap.sh" if build.head?
    system ".configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "decasify v#{version}", shell_output("#{bin}decasify --version")
    assert_match "Ben ve İvan", shell_output("#{bin}decasify -l tr -c title 'ben VE ivan'")
  end
end