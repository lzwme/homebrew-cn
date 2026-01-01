class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.43-r2.tar.gz"
  version "6.43-r2"
  sha256 "e219ac8e86a8052a0891523ab77daeb4124727a3611da5fb256a78ac6c71e157"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  livecheck do
    url "https://ifarchive.org/indexes/if-archive/infocom/compilers/inform6/source/"
    regex(/href=.*?inform[._-]v?(\d+(?:[.-]\d+)+(?:[._-]r\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8c843f9a1939ae049a25d3bec9138595f6d4d2620ab7056a711e98d60ff38fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21924b06e1a2a74cd3ca4f731edcca43fe4005b60c165281c8fbb8d1f3ce9838"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db0da654ce49ebdec0892e4e44f6d292b93fccc5461eba33ebb65fa07edcf9db"
    sha256 cellar: :any_skip_relocation, sonoma:        "02671c979c8a2b47f85eab4eb19fabb7708fe93f1004b7ca2e4e3814610b9d65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4c326710caecf7b3e65b64e047ab0bba9b804b426cc81f9bacf21822335eb0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22ab663eea064695e21e15fffee1da68ff9882f90939fdd31e2de3286e96c54e"
  end

  def install
    # Parallel install fails because of: https://gitlab.com/DavidGriffith/inform6unix/-/issues/26
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "MANDIR=#{man1}", "install"
  end

  test do
    resource "homebrew-test_resource" do
      url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
      sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
    end

    resource("homebrew-test_resource").stage do
      system bin/"inform", "Adventureland.inf"
      assert_path_exists Pathname.pwd/"Adventureland.z5"
    end
  end
end