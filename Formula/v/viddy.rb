class Viddy < Formula
  desc "Modern watch command"
  homepage "https:github.comsachaosviddy"
  url "https:github.comsachaosviddyarchiverefstagsv1.1.3.tar.gz"
  sha256 "715846c8cef404c56325766781b4fc015e805f6a20435f08842262dca244fc65"
  license "MIT"
  head "https:github.comsachaosviddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4145ce20a9f9da725e3f0faeca92cadade196198cbf96843d572d5bd83d91832"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37bb8b6f8992a88aac0b1110bec2d208f58c61341c71206e947a024c1a5f1980"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "431048e14383439df04c4e5e18a84132815dad2fa797054bff8bd9fe5ef2f86b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ad1668f9f280a82bdc5d01def46eae09ae43140e4b0b385e0733303870298e6"
    sha256 cellar: :any_skip_relocation, ventura:       "e0873e16dd2f8b91085cbc1d90efbd547e56946b23b819180f14df2b3634fe59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bafd5772eff6c44834d7f64ddb3f822012440963affb3cd8ee2d49996bbadea"
  end

  depends_on "rust" => :build

  # version patch, upstream pr ref, https:github.comsachaosviddypull156
  patch do
    url "https:github.comsachaosviddycommite20aa1aba227c90b9616144ae13676e2217c4563.patch?full_index=1"
    sha256 "0784e58b7e1c03b751db54574fec85a203ae3fb8983418b5b703dd36fa08aa1b"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Inputoutput error @ io_fread - devpts0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      pid = fork do
        system bin"viddy", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "viddy #{version}", shell_output("#{bin}viddy --version")
  end
end