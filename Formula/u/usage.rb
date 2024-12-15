class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv1.6.0.tar.gz"
  sha256 "583cc0621222af52db07c4ce1ec921f73bfda7941475da6b968b988d576c2e3f"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f45c21a8dc1f30d25a5c01f6291c11d97cf97f4a3e36dec9a4bcbc5b9f9392e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc685d8468e5b73ed53143e64f735ec72925b093c2e868296ccdc50bc94e4a92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c909153b6c89073a032f2fb83d296d153c7296e64ef6e13aa910face878fd89"
    sha256 cellar: :any_skip_relocation, sonoma:        "d49146fa5d358c07ca126abba0d02728aaae3a01efac974a230fd349f503951a"
    sha256 cellar: :any_skip_relocation, ventura:       "60806d06f5c917a330891a4e8b7f92b8a4e860838b572b388641b504a979fa24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "013c97cc0897bf17ab2fdec305582fcf21a336d156d72bdf4429dfb424d6af44"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin"usage --version").chomp
    assert_equal "--foo", shell_output(bin"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end