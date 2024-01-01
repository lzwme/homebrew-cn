class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https:github.comnoir-crnoir"
  url "https:github.comnoir-crnoirarchiverefstagsv0.12.0.tar.gz"
  sha256 "25660741e04a7c4e617fcb1fbfdbb85568665b13126325bde58545dffda7a935"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "c8585e77b5eb913e8a9885bda4c4851a7fcffabbb6c59e720136c4011ed7c37c"
    sha256 arm64_ventura:  "e29aaeb651869280e6551f2f221f0b93de1f54ed61409b946d70e48ce4943c27"
    sha256 arm64_monterey: "b75c2e1232ecd0e92c6981929b808b407483a4d34ff1385cd0266d59c0f88ea1"
    sha256 sonoma:         "be2881417dc0490bc8d287079dca15214cc909c2220f3169f13a79b0f16ba0d3"
    sha256 ventura:        "cee19674ef910ec858390e4c27a6a40c1c7181e8d9a19325ca91f770b990cc23"
    sha256 monterey:       "b83178de23b77667ddf9dad08dd91e9b9ac57282baffddac78a27af2f9048c72"
    sha256 x86_64_linux:   "5e01f1cf10a8bd72036de9a242da967b15aaa5c3abe77b9a83c5a46417cd039a"
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