class Cdlabelgen < Formula
  desc "CD/DVD inserts and envelopes"
  homepage "https://www.aczoom.com/tools/cdinsert/"
  url "https://www.aczoom.com/pub/tools/cdlabelgen-4.3.0.tgz"
  sha256 "94202a33bd6b19cc3c1cbf6a8e1779d7c72d8b3b48b96267f97d61ced4e1753f"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.aczoom.com/pub/tools/"
    regex(/href=.*?cdlabelgen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b29161d97190eea5c2afc549dbc0cf1511db27b0c48e00ff225373c135d678b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ac1cd2a6a78abdd5adff5ac90d8eb311ca1113f9a673097ae25d8619dd24eb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ba8549a259b725eb231f8ae136a290a24156dc267050796bbff796f6135c9f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ba8549a259b725eb231f8ae136a290a24156dc267050796bbff796f6135c9f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ba8549a259b725eb231f8ae136a290a24156dc267050796bbff796f6135c9f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "6017838a534fbaa5f33c5905867926df9160c33e25bb4b78302708f1f73ea157"
    sha256 cellar: :any_skip_relocation, ventura:        "584f58b2a0815c049eef3b967afe1563fe3fb6251224b69b7b1622407aeda35c"
    sha256 cellar: :any_skip_relocation, monterey:       "584f58b2a0815c049eef3b967afe1563fe3fb6251224b69b7b1622407aeda35c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c1096a23f2ce2b8db912fcb9786c2f9d76b7ece60d2269512e90fa9505d0d9e"
    sha256 cellar: :any_skip_relocation, catalina:       "5facce52a8f22279160a388513b2a9406f427f3ab231e119fbc0b074dc7028f9"
    sha256 cellar: :any_skip_relocation, mojave:         "5162ba8c34a6aeef369b5004d1608fa2b8de5a33350f1d7629f08eed8b18d5d9"
    sha256 cellar: :any_skip_relocation, high_sierra:    "ece93bae3d8b9e6e5c37b347849836dc970183efcea603d7d3b6f8f0dbaebd4a"
    sha256 cellar: :any_skip_relocation, sierra:         "a874e660972a4ac722e56e13749a17f3c76c5fa61691f44d70afb13c88e4e65f"
    sha256 cellar: :any_skip_relocation, el_capitan:     "34758541efaf3e124ff531d09cdf3f511651be8602f179de1e5ecd606b0aa60b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bb17ad7e1c031428b9df3ade55d9f89ac1cace0cbf720a8123bc5c5f479f4d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ba8549a259b725eb231f8ae136a290a24156dc267050796bbff796f6135c9f8"
  end

  def install
    man1.mkpath
    system "make", "install", "BASE_DIR=#{prefix}"
  end

  test do
    system bin/"cdlabelgen", "-c", "TestTitle", "-t", pkgshare/"template.ps", "--output-file", "testout.eps"
    File.file?("testout.eps")
  end
end