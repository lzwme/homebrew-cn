class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https:github.comashishbgabo"
  url "https:github.comashishbgaboarchiverefstagsv1.3.1.tar.gz"
  sha256 "e4ee22bf70b54dcf4e500cd73271fba858b5007fdcf8356c20556225b9e45370"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "927e72f8dfa3a82635e53f2f4de8c83a7d7145250a735faee21e1c884e61dee0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "927e72f8dfa3a82635e53f2f4de8c83a7d7145250a735faee21e1c884e61dee0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "927e72f8dfa3a82635e53f2f4de8c83a7d7145250a735faee21e1c884e61dee0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d88f0baa044e096d7da59e1772ad906fbfd9e6496a7e44375dc52a4573396e8"
    sha256 cellar: :any_skip_relocation, ventura:       "8d88f0baa044e096d7da59e1772ad906fbfd9e6496a7e44375dc52a4573396e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c99ae0e97b2b7bbef5ad821f09962361ea0176b7c6b467e178fe965bb3cc8286"
  end

  depends_on "go" => :build

  def install
    cd "srcgabo" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdgabo"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gabo --version")

    gabo_test = testpath"gabo-test"
    gabo_test.mkpath
    (gabo_test".git").mkpath # Emulate git
    system bin"gabo", "-dir", gabo_test, "-for", "lint-yaml", "-mode=generate"
    assert_predicate gabo_test".githubworkflowslint-yaml.yaml", :exist?
  end
end