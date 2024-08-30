class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https:cooperspencer.github.iogickup-documentation"
  url "https:github.comcooperspencergickuparchiverefstagsv0.10.33.tar.gz"
  sha256 "9703c4bb55d999ac5744c28cc92e7c9449d045dbe3c5e25d7753399417d1bccc"
  license "Apache-2.0"
  head "https:github.comcooperspencergickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b803c9bda5e513fcdb5031f6cb99334da35251dc8f29d35c73e7664710c37e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b803c9bda5e513fcdb5031f6cb99334da35251dc8f29d35c73e7664710c37e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b803c9bda5e513fcdb5031f6cb99334da35251dc8f29d35c73e7664710c37e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "122f8a4534c7b0a32e16b9c2bbd47b78b23a1a1baee0427372cc0c5fb326694e"
    sha256 cellar: :any_skip_relocation, ventura:        "122f8a4534c7b0a32e16b9c2bbd47b78b23a1a1baee0427372cc0c5fb326694e"
    sha256 cellar: :any_skip_relocation, monterey:       "122f8a4534c7b0a32e16b9c2bbd47b78b23a1a1baee0427372cc0c5fb326694e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03301c0f8a925df95e4ecbc6cd8e95f759d0068925bc27aa20a7f4cdfa31e7a4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath"conf.yml").write <<~EOS
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    EOS

    output = shell_output("#{bin}gickup --dryrun 2>&1")
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}gickup --version")
  end
end