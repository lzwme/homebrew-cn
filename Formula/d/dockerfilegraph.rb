class Dockerfilegraph < Formula
  desc "Visualize your multi-stage Dockerfiles"
  homepage "https:github.compatrickhoeflerdockerfilegraph"
  url "https:github.compatrickhoeflerdockerfilegrapharchiverefstagsv0.17.10.tar.gz"
  sha256 "74f1f8d986149cd239d3fa4ecafc45f34076b1abaa3f6cb26d7eec52a6791c1a"
  license "MIT"
  head "https:github.compatrickhoeflerdockerfilegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e21fd8811676dd3e118643887c4be1d461135099d242bc4dfd7e03865f99d967"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e21fd8811676dd3e118643887c4be1d461135099d242bc4dfd7e03865f99d967"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e21fd8811676dd3e118643887c4be1d461135099d242bc4dfd7e03865f99d967"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f311726ad5127bba9ba18276d612eabcc76185dd9e23cc04018e10c4846642c"
    sha256 cellar: :any_skip_relocation, ventura:       "1f311726ad5127bba9ba18276d612eabcc76185dd9e23cc04018e10c4846642c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db0db365f115b033077ee99d0cd540182bfeaaf394989caf04aa36e6e182095c"
  end

  depends_on "go" => :build
  depends_on "graphviz"

  def install
    ldflags = %W[
      -s -w
      -X github.compatrickhoeflerdockerfilegraphinternalcmd.gitVersion=#{version}
      -X github.compatrickhoeflerdockerfilegraphinternalcmd.gitCommit=#{tap.user}
      -X github.compatrickhoeflerdockerfilegraphinternalcmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}dockerfilegraph --version")

    (testpath"Dockerfile").write <<~DOCKERFILE
      FROM alpine AS base
      RUN echo "Hello, World!" > hello.txt

      FROM base AS final
      COPY --from=base hello.txt hello.txt
    DOCKERFILE

    output = shell_output("#{bin}dockerfilegraph --filename Dockerfile")
    assert_match "Successfully created Dockerfile.pdf", output
    assert_path_exists testpath"Dockerfile.pdf"
  end
end