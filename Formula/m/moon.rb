class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.25.1.tar.gz"
  sha256 "56dc5c5961877fbe5ebdc15e28c8a7274ccd47a8c80f795e79fedd3012eff229"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10aa17aabdef3d9fbcc4146913dabd99764672690eb20027e06206e86ddd9a5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab6d5a7b8b5bb54e9f37ce4897d54c42f4799e04583a882f594d2d8eca767535"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c5541daa2ff16a935c4943a621d1f3a4814dca931f7e5ed35c4adae5437d666"
    sha256 cellar: :any_skip_relocation, sonoma:         "3abe282b2d7539d1556cdaaeae15c6eb98c89ccf0530db52ab96bb42280c67ab"
    sha256 cellar: :any_skip_relocation, ventura:        "a62967c75fdd7da22a4e70f5e07303c0be988791d47ac4ca2ee197a4d0bf3fcc"
    sha256 cellar: :any_skip_relocation, monterey:       "f298d4873734ed750e0b809039d7882dcedc0e1a9ea68bc8b9b8df6520596cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fa81e406f7292e972ac69d80fa0623d1c862483438ebd178964975c7256f4f4"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "legacycli")
    generate_completions_from_executable(bin"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec"bin").install f
      (binbasename).write_env_script libexec"bin"basename, MOON_INSTALL_DIR: opt_prefix"bin"
    end
  end

  test do
    system bin"moon", "init", "--minimal", "--yes"
    assert_predicate testpath".moon""workspace.yml", :exist?
  end
end