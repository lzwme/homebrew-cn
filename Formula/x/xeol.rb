class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https://github.com/xeol-io/xeol"
  url "https://ghproxy.com/https://github.com/xeol-io/xeol/archive/refs/tags/v0.9.10.tar.gz"
  sha256 "cf74990385fdccda05469e9aa996ff88707b05a3988f5985c292f70957e9366f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acb505c566daf79f0f1e2d310c2eccba8c57d814ec0502261f0f80e5d0ca0568"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "282b3fcd8ef7b14e4effabc663bd900a977178a4e4d1554e4ba8165f0c3ab240"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cea8c1d50aea001ff30cbd21d19ecd29f90de11e949496b094200bf22ce4e31"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b64ac6115cc014b9f99e2a2ff7d8b6e24e395705324e79917c38aecac3415ed"
    sha256 cellar: :any_skip_relocation, ventura:        "a06d5bf5e8ab6d12ec453769e143c4aef412b6003db077a00432d710d228d7ab"
    sha256 cellar: :any_skip_relocation, monterey:       "8d72cb465753c9f2065d5daabd09dba885b4fd706394ebc395736a83d2918747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ced4cda358826d5b40bafe7a638d0dd3d0304c3dd17d15ff10ec9af767ae9466"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
      -X main.gitDescription=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/xeol"

    generate_completions_from_executable(bin/"xeol", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xeol version")

    output = shell_output("#{bin}/xeol alpine:latest")
    assert_match "no EOL software has been found", output
  end
end