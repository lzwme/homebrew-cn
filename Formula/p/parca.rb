class Parca < Formula
  desc "Continuous profiling for analysis of CPU and memory usage"
  homepage "https:www.parca.dev"
  url "https:github.comparca-devparcaarchiverefstagsv0.23.0.tar.gz"
  sha256 "3250d0da865b395f3ceb663c18c50f433b553a8d8339b1ae5cfa95d77cf7d3d3"
  license "Apache-2.0"
  head "https:github.comparca-devparca.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bb5c629b89ac734fac86e534ea55f87d6bb1d0af2bd6e7e601dcdcdbe444ef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bb5c629b89ac734fac86e534ea55f87d6bb1d0af2bd6e7e601dcdcdbe444ef7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bb5c629b89ac734fac86e534ea55f87d6bb1d0af2bd6e7e601dcdcdbe444ef7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b95f1771c4a22811fea4dffbe49e6138e5cee8ef2c6a92fdbb33b98805752777"
    sha256 cellar: :any_skip_relocation, ventura:       "b95f1771c4a22811fea4dffbe49e6138e5cee8ef2c6a92fdbb33b98805752777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b10a1557d1f8e1894eb4a294a7e499398ceff984dea5bf139e948624c93f9bf"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  # remove unused `@ts-expect-error` directive, upstream pr ref, https:github.comparca-devparcapull5518
  patch do
    url "https:github.comparca-devparcacommita99156d7a5c8f6a1a42f1f83f7af864cbc11fef8.patch?full_index=1"
    sha256 "01d5f31de779146e333a55f4371f20f39a554d2b9f8e2fe78b9ba747650d14c6"
  end

  def install
    system "pnpm", "--dir", "ui", "install"
    system "pnpm", "--dir", "ui", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdparca"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}parca --version")

    # server config, https:raw.githubusercontent.comparca-devparcacbfa19e032ee51fccd6ca9a5842129faeb27c106parca.yaml
    (testpath"parca.yaml").write <<~YAML
      object_storage:
        bucket:
          type: "FILESYSTEM"
          config:
            directory: ".data"
    YAML

    output_log = testpath"output.log"
    pid = spawn bin"parca", "--config-path=parca.yaml", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "starting server", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end