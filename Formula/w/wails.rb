class Wails < Formula
  desc "Create beautiful applications using Go"
  homepage "https:wails.io"
  url "https:github.comwailsappwailsarchiverefstagsv2.9.3.tar.gz"
  sha256 "e9d43fba72b14845ab58cb8cd4daaeaabbb9bc1d57f84171cea554d6778e3cde"
  license "MIT"
  head "https:github.comwailsappwails.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49010ef0a17da86b7fcc5c2b3431df0035aee259aa9664088ab39207a85236df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49010ef0a17da86b7fcc5c2b3431df0035aee259aa9664088ab39207a85236df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49010ef0a17da86b7fcc5c2b3431df0035aee259aa9664088ab39207a85236df"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce8b7c7a8d0a9ef62aaa94268e2b79c32ce39819f2322139c7ec8b2c356d1367"
    sha256 cellar: :any_skip_relocation, ventura:       "ce8b7c7a8d0a9ef62aaa94268e2b79c32ce39819f2322139c7ec8b2c356d1367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9eca3145b2dea00a4cc6a58de02683a706a812dd3a859a08334c88d670de2083"
  end

  depends_on "go"

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdwails"
    end
  end

  test do
    ENV["NO_COLOR"] = "1"

    output = shell_output("#{bin}wails init -n brewtest 2>&1")
    assert_match "# Initialising Project 'brewtest'", output
    assert_match "Template          | Vanilla + Vite", output

    assert_path_exists testpath"brewtestgo.mod"
    assert_equal "brewtest", JSON.parse((testpath"brewtestwails.json").read)["name"]

    assert_match version.to_s, shell_output("#{bin}wails version")
  end
end