class Rnr < Formula
  desc "Command-line tool to batch rename files and directories"
  homepage "https:github.comismaelgvrnr"
  url "https:github.comismaelgvrnrarchiverefstagsv0.5.0.tar.gz"
  sha256 "b8edab04e1129b8caeb0c8634dd3bbc9986528c5ec479f7e7f072dbe7bf9ba20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fb09c89cda8bafe101e6c2de4d9afd0efd149b21bd37ce9b00653a7fbef1d21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdfb6fee01547e1e695afbcac85ec3cd59655d270615aae6269e84bab4697b71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7170e9081556544c8b27af2d92e01ad44cbf4efb5e3cf03f9577a50a7e96a92"
    sha256 cellar: :any_skip_relocation, sonoma:        "353575eefa7409b139607ee46d2d10149759a221687295c6fde7cd13e3c29c91"
    sha256 cellar: :any_skip_relocation, ventura:       "aeea1bdde84bb59dffaedfc516b70ed439cb66b8ee280c3fe4f269bdc4505577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c855c741dbb39266333bb2ceac02eaf1cfab99be891bfa88cebe0bbed52c6df"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    deploy_dir = Dir["targetreleasebuildrnr-*out"].first
    zsh_completion.install "#{deploy_dir}_rnr" => "_rnr"
    bash_completion.install "#{deploy_dir}rnr.bash" => "rnr"
    fish_completion.install "#{deploy_dir}rnr.fish"
  end

  test do
    touch "foo.doc"
    mkdir "one"
    touch "onefoo.doc"

    system bin"rnr", "regex", "-f", "doc", "txt", "foo.doc", "onefoo.doc"
    refute_predicate testpath"foo.doc", :exist?
    assert_predicate testpath"foo.txt", :exist?

    assert_match version.to_s, shell_output("#{bin}rnr --version")
  end
end