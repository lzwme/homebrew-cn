class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https:github.comsymfony-clisymfony-cli"
  url "https:github.comsymfony-clisymfony-cliarchiverefstagsv5.10.9.tar.gz"
  sha256 "1b08e646f8127436deeb7dab910248a061381e7a8e742c34e713d96d0ee30e3a"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3d44f4b39a0d1d768609b751335b2db68f3f87acb58784e4f2115639b1e9a36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5276fb13996a98d1618eca0d980bfb0b38318726314531b5309d247c89ada9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d125116a9b167738a5800a673f1e8ce618af9419b66e5a9e7384a35ba839bb67"
    sha256 cellar: :any_skip_relocation, sonoma:        "1765f205f0e619fc611794d321422c29aef168ae08c756953f257c8ba2ad6abe"
    sha256 cellar: :any_skip_relocation, ventura:       "c3fc60a89d17483696afbba04fe1ba0260954099f5d12d985d5ab38c12525fba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebe5b368ef3f7464ad6831ca72ca2db0b36f2ed4f979124070e3556cffd96a71"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}", output: bin"symfony")
  end

  test do
    system bin"symfony", "new", "--no-git", testpath"my_project"
    assert_path_exists testpath"my_projectsymfony.lock"
  end
end