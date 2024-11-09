class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https:wiki.metacubex.one"
  url "https:github.comMetaCubeXmihomoarchiverefstagsv1.18.10.tar.gz"
  sha256 "98e5c79fd5bec5478ffb3972d28a0474034a9abbd7dde2859c0c891ab5b71b2d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b9071c7fa695607cc8f26d182b56f5eaa85565210c32dffb4d0c0cae7643fe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8994600c401575fe3bd1455528aef03142185d64c8d4f7451cb6ae1edadac61a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5dcae5afe31053e02fea7030fa775ca99d79892c9fb949e97f7950a7bfeadea"
    sha256 cellar: :any_skip_relocation, sonoma:        "a76c78c1d661b10a17eb9c6cb8dc0f3fdbcf7493eb58e0bd57d346c424fd6825"
    sha256 cellar: :any_skip_relocation, ventura:       "612c7983f62c1bafd916af8b9421a2a675fffa2ad6d41b9fb05e2d24da78eba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8ed15b08074a532496007c364df8002e390b546a16a7ab208ad8f8693609960"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X "github.commetacubexmihomoconstant.Version=#{version}"
      -X "github.commetacubexmihomoconstant.BuildTime=#{time.iso8601}"
    ]
    system "go", "build", "-tags", "with_gvisor", *std_go_args(ldflags:)

    (buildpath"config.yaml").write <<~YAML
      # Document: https:wiki.metacubex.oneconfig
      mixed-port: 7890
    YAML
    pkgetc.install "config.yaml"
  end

  def caveats
    <<~EOS
      You need to customize #{etc}mihomoconfig.yaml.
    EOS
  end

  service do
    run [opt_bin"mihomo", "-d", etc"mihomo"]
    keep_alive true
    working_dir etc"mihomo"
    log_path var"logmihomo.log"
    error_log_path var"logmihomo.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}mihomo -v")

    (testpath"mihomoconfig.yaml").write <<~YAML
      mixed-port: #{free_port}
    YAML
    system bin"mihomo", "-t", "-d", testpath"mihomo"
  end
end