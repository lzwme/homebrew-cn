class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https:github.comnoir-crnoir"
  url "https:github.comnoir-crnoirarchiverefstagsv0.14.0.tar.gz"
  sha256 "c5b2e6bf792d34b389dad97f7a1ecddbb4b25adfe1463f31c16f0c958cf00680"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "f27ad076541251422669c1cbec1977ea25a6196efbeb6896be395794bce96685"
    sha256 arm64_ventura:  "7ea18d56fdaa3bcd5851a9f26f5baa9c21a9b2041781c3b24bffc470fd7e72c8"
    sha256 arm64_monterey: "b55222b574bfbfd8f0fb61f760997b5481777db72d59afe14e38847e3a4117c2"
    sha256 sonoma:         "74156cd01d6f1beaa0df5f6f106bc60833f701a8ca6a77acaca11b1a0c765302"
    sha256 ventura:        "0350a8dc1cbe76010fd5d53b66f04e9bff4853f8cc069648deaccbd89e75ee63"
    sha256 monterey:       "6a17f6ecf43805b7e4d30daa6698c5ed33c46722ed8ed5415d7ec6dcf32f2f07"
    sha256 x86_64_linux:   "972987221c8265706625f360f07980d5a826b1c664cf3e8a9626a017c14fb852"
  end

  depends_on "crystal"

  def install
    system "shards", "install"
    system "shards", "build", "--release", "--no-debug"
    bin.install "binnoir"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}noir --version")

    system "git", "clone", "https:github.comnoir-crnoir.git"
    output = shell_output("#{bin}noir -b noir 2>&1")
    assert_match "Generating Report.", output
  end
end