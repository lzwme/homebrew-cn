class Dud < Formula
  desc "CLI tool for versioning data"
  homepage "https:kevin-hanselman.github.iodud"
  url "https:github.comkevin-hanselmandudarchiverefstagsv0.4.5.tar.gz"
  sha256 "57f63d260c8a0a0f925bb67e3634f1211c69b07a7405215b53c38d8563119425"
  license "BSD-3-Clause"
  head "https:github.comkevin-hanselmandud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e40fc688de77f2aa11aaf87d123516aa14883010c37e6ba1bc8e035dc6ee1dfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e40fc688de77f2aa11aaf87d123516aa14883010c37e6ba1bc8e035dc6ee1dfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e40fc688de77f2aa11aaf87d123516aa14883010c37e6ba1bc8e035dc6ee1dfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ba8951fd0efc9b6a64503491025a2f9b6a0a741e3fcd147dc5f0855a9333a51"
    sha256 cellar: :any_skip_relocation, ventura:       "9ba8951fd0efc9b6a64503491025a2f9b6a0a741e3fcd147dc5f0855a9333a51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6d2d41cbcbda86daf9354b22905a9bdc50b1b866e9727510929ce13a11eb837"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
    generate_completions_from_executable(bin"dud", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}dud version")
    system bin"dud", "init"
    assert_predicate testpath".dudconfig.yaml", :exist?
  end
end