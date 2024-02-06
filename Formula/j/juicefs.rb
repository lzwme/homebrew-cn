class Juicefs < Formula
  desc "Cloud-based, distributed POSIX file system built on top of Redis and S3"
  homepage "https:juicefs.com"
  url "https:github.comjuicedatajuicefsarchiverefstagsv1.1.2.tar.gz"
  sha256 "378dccf9e0ca90d3643b91bfb88bb353fb4101f41f9df9519d67d255fb18af58"
  license "Apache-2.0"
  head "https:github.comjuicedatajuicefs.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a4385a72cbb04b319637141e9a810bdea47c0c192c64c32b35a06a9f2010533"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a567df16a9c4843595b3aa65c6435eeaa671f68346e48e898e49eeb8302fd295"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80a3b33a6b455411e4492ff2cac06fdd16dcca92424a2a4bc84a9727a1b84b61"
    sha256 cellar: :any_skip_relocation, sonoma:         "76e9ad3fef06a183506b8fe163070e44b07ab16c3e4566d89d77bcbf4fd0f361"
    sha256 cellar: :any_skip_relocation, ventura:        "47c5a9469c61b6c0e580eb76fabc6205626adff2193432f35131f6e327d012f2"
    sha256 cellar: :any_skip_relocation, monterey:       "f34ca0d654680c02ef417bf293dab5ae7d98ca7cd6882e6dea5bb7ba5916d1be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d0f01c6689b8a3ee1565cf80752214efd2e6fcd6a2edb429171bdfc440c04f5"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "juicefs"
  end

  test do
    output = shell_output("#{bin}juicefs format sqlite3:test.db testfs 2>&1")
    assert_predicate testpath"test.db", :exist?
    assert_match "Meta address: sqlite3:test.db", output
  end
end