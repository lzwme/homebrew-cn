class Dura < Formula
  desc "Backs up your work automatically via Git commits"
  homepage "https:github.comtkelloggdura"
  url "https:github.comtkelloggduraarchiverefstagsv0.2.0.tar.gz"
  sha256 "6486afa167cc2c9b6b6646b9a3cb36e76c1a55e986f280607c8933a045d58cca"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "0b2c2b2aa810e3f4a183d0ebed078c330c830d0512c5e4c38ea44fee654b1d15"
    sha256 cellar: :any,                 arm64_sonoma:   "0eec39a4d6a29b38fdd44900472c4932ffec202c85b3657399fe9f0c6a390ca3"
    sha256 cellar: :any,                 arm64_ventura:  "9afb3146b424af7ac38eb1054ba8ed6f6f918c4eeb3a1ebce44696b9c59af8c1"
    sha256 cellar: :any,                 arm64_monterey: "fedf4c54dd1cc680b6dbdf2534b69d9b8e256e067636b0fcbb531ea0b5cb8476"
    sha256 cellar: :any,                 arm64_big_sur:  "6e9e81ec0f29a48921d55bb3168648fbef695dc3d1a242c6aa851bfdf3575dca"
    sha256 cellar: :any,                 sonoma:         "3affeb2e58b7d362dedc72f72d05423425f29227a64d7d7dde4c8a36a73274e9"
    sha256 cellar: :any,                 ventura:        "d4ef7d4344c67c86442066f7b09e11e5224b93c607dfbea0e91d08eea9f8d38b"
    sha256 cellar: :any,                 monterey:       "189cbc09ab1621aa501666194c27b9616a9b0674ace36ac981896a02816bbc25"
    sha256 cellar: :any,                 big_sur:        "c01130844f54014c8ad174037da08ac04ec826811c89e917c388662d61f92bd2"
    sha256 cellar: :any,                 catalina:       "b0279f3f31e75da9843e5a0ad3bbcae62a29277153c8e8992d4de490397aca70"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1863734bc30dd7f8ea317fe0b498279bc71a9b2e6d41b9931fb8f81a6b604e51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b01d4685f6aa2d5fe11722b7c7379695600d6827fa48bd72addebc9cfbd16968"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin"dura", "serve"]
    keep_alive true
    error_log_path var"logdura.stderr.log"
    log_path var"logdura.log.json"
    working_dir var
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    assert_match(commit_hash:\s+\h{40}, shell_output("#{bin}dura capture ."))
  end
end