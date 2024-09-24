class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.28.3.tar.gz"
  sha256 "235090dd505284be5402facfd506007c2505a0aa98df4f54d18a8f8e2a86ce97"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f468402e081dc113311313d21f715c0773e376e576d9aa09dc5c9665c8aebfef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4339b740c9bf0f7019d8ca879b1d1f8dad2a9d708091ecede3cbf4430e1d76cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07e8ceef9dadc5b37b75b66ce81e1f9da0f6d45fa1b226948d07aa2aa983c8cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b6481e49477c483ab87e3caf90919fe2e383bbc9d63dedbde8bbae8b6018e32"
    sha256 cellar: :any_skip_relocation, ventura:       "f6eb2ce23ee43010f58cbae45d520a8425a0dfb04024c0d1102cdeb724eb7b20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e9ca617cea766545f7c891cc56046f1bb1115ea76c452a05a5c3924b43b6af3"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
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