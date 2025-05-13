class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https:wiki.metacubex.one"
  url "https:github.comMetaCubeXmihomoarchiverefstagsv1.19.7.tar.gz"
  sha256 "b857289776f6ecfedaaca2cdfd9ed39746fda697bdcbbbb0b1bb172f1fc9462d"
  license "GPL-3.0-or-later"
  head "https:github.comMetaCubeXmihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "487576b7e27d005c4cee7384ac0830a575fb3dcf7166d53d16906c0dc2e44d98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f702ad61337d91be9fc642ec846204ad38c28690ac0f64e01316f8f11284b79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78a672edd9e01f7a674ace6fc640f055b26e69b8f665c9c7faf7e1ef86662ddd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec2f4d95c9f7c0b67dc6ef3b513416b54732048344243f93317ea4dbd610e713"
    sha256 cellar: :any_skip_relocation, ventura:       "560392420fe5861818ef20959230fb670c79d47459dfb586185452648c44a455"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a99064668fc1d1d5168e3b039b6a6638b5737b77b930811ea89ce9456f0c934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "347cf3b11d7c3b9744c1b333dc9e917d9ef2b468c85ceb5b96b8b86969dae900"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X "github.commetacubexmihomoconstant.Version=#{version}"
      -X "github.commetacubexmihomoconstant.BuildTime=#{time.iso8601}"
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "with_gvisor")

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