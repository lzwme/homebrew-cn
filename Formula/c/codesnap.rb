class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https:github.comcodesnap-rscodesnap"
  url "https:github.comcodesnap-rscodesnaparchiverefstagsv0.12.3.tar.gz"
  sha256 "4f0fb830cea43c197530f82896908646b389d2b9d5a6cdab8a344241ca6a79e7"
  license "MIT"
  head "https:github.comcodesnap-rscodesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa1c2b995faae52597b835dc4110e415b09e9962cb8c5f2420b768700bd9271d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa05440c837a5fb916c55fcc23fbebe494d8d42d4bcbaeafa15de0bc1678d849"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b5501bcffcbf376117cd17e49b4880863c47df0a909e75673b9ca128e660b3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6755a7d529df1b10104ff6d80c4932ca3bfe44490bae9b8080db20d9cdb0ed78"
    sha256 cellar: :any_skip_relocation, ventura:       "a0a20b587d2ee163df60afd5c76401ed112d1ac61128ec923064773d55869a5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc3a633e4742c10a0e3be34860585907e64271ae2b799c685c8e894cb653603b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ead9ea80f15498ed088c8b99bced2998e2320ab6d3b717bdf2d343075208c39"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cliexamples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}codesnap -f #{pkgshare}examplescli.sh -o cli.png")
  end
end