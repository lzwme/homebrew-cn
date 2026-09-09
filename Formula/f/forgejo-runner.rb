class ForgejoRunner < Formula
  desc "Official Actions runner for Forgejo instances"
  homepage "https://code.forgejo.org/forgejo/runner"
  url "https://code.forgejo.org/forgejo/runner/archive/v13.1.0.tar.gz"
  sha256 "bdece01a00354bb29de4e36b6c72afae9ed571ed1fba1905d01bc8961de41819"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://code.forgejo.org/api/v1/repos/forgejo/runner/releases/latest"
    strategy :json do |json|
      json["tag_name"]&.delete("v")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9ef417a682da199d5d02b48162493df45ac7c6519137be2797316cbe7a7eb05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9ef417a682da199d5d02b48162493df45ac7c6519137be2797316cbe7a7eb05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9ef417a682da199d5d02b48162493df45ac7c6519137be2797316cbe7a7eb05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a4e16724efb1b7658a483b2b9ad0d6c673af4f64757ae62a92e9ae8cbb6caf7"
    sha256 cellar: :any,                 x86_64_linux:  "31e774ea791448d03684211d1b9d9d3e5f09f8f959c8ae9059d8957b08b6c3c2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X code.forgejo.org/forgejo/runner/v#{version.major}/internal/pkg/ver.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"forgejo-runner", shell_parameter_format: :cobra)

    (buildpath/"config.yaml").write Utils.safe_popen_read(bin/"forgejo-runner", "generate-config")
    pkgetc.install "config.yaml"
  end

  def caveats
    "Config file: #{pkgetc}/config.yaml"
  end

  service do
    run [opt_bin/"forgejo-runner", "daemon", "--config", etc/"forgejo-runner/config.yaml"]
    keep_alive successful_exit: true
    environment_variables PATH: std_service_path_env

    working_dir var/"lib/forgejo-runner"
    log_path var/"log/forgejo-runner.log"
    error_log_path var/"log/forgejo-runner.err"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/forgejo-runner --version")
    output = shell_output("#{bin}/forgejo-runner generate-config")
    assert_match "container:", output
  end
end