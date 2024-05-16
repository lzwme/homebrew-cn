class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage "https:github.comndevillainiparser"
  url "https:github.comndevillainiparserarchiverefstagsv4.2.1.tar.gz"
  sha256 "9120fd13260be1dbec74b8aaf47777c434976626f3b3288c0d17b70e21cce2d2"
  license "MIT"
  head "https:github.comndevillainiparser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bd9e7fd492164e6e74b2eb9b3ac322f13b0a383b55ac5c7d60ae20063093367"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae8b0bc1a4d2edce09a3e9cd5771853c0d26eddc78b3e9dd3ba394c622f88e35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "298cac18a7200dfda350aa218c12db2ed5ecddba1fff2969bef99cd0461318e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f763885403551ab79db25a4ba0c3bd8abf590a774395feaad050e37a9ba6a77"
    sha256 cellar: :any_skip_relocation, ventura:        "5a7f176c604c0a24cc81d58989079e385665cf8e04e6f9c973537d324636a367"
    sha256 cellar: :any_skip_relocation, monterey:       "304dfe192cec416dec4e74a941cf4ad34332f6866b1d4484dfadf746ea63f441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c601ef4b4010ba20349b8a3098894b2fc1f6303cc6c126b3786e395584fe1a24"
  end

  conflicts_with "fastbit", because: "both install `includedictionary.h`"

  def install
    # Only make the *.a file; the *.so target is useless (and fails).
    system "make", "libiniparser.a", "CC=#{ENV.cc}", "RANLIB=ranlib"
    lib.install "libiniparser.a"
    include.install Dir["src*.h"]
  end
end