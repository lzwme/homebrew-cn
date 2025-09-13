class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://www.greenmask.io/"
  url "https://ghfast.top/https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "107b29d94f79dede9d414323f50b9b2c286bd19dc585e5d55dd4cc4d2a415d48"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b82dca8fa1cc710f99a366af3598095cfb841843ffd02eb350a14fdbceb9020b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "935c86fce1c7a36a5fec1c261b180fdc6144291c481717c6f563b08dfca1a811"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "935c86fce1c7a36a5fec1c261b180fdc6144291c481717c6f563b08dfca1a811"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "935c86fce1c7a36a5fec1c261b180fdc6144291c481717c6f563b08dfca1a811"
    sha256 cellar: :any_skip_relocation, sonoma:        "da1a0a709ccabe12ce1ac95dd2eaa81d623cec9ba92e7b1e1a4848c14c5f3c3a"
    sha256 cellar: :any_skip_relocation, ventura:       "da1a0a709ccabe12ce1ac95dd2eaa81d623cec9ba92e7b1e1a4848c14c5f3c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f07d134e1744a3a0c4d60fd043d89e8b453eb212a0db682761d59d4a375b6a3f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/greenmaskio/greenmask/cmd/greenmask/cmd.Version=#{version}
    ]
    system "go", "build", "-tags=viper_bind_struct", *std_go_args(ldflags:), "./cmd/greenmask"

    generate_completions_from_executable(bin/"greenmask", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/greenmask -v")

    (testpath/"config.yml").write <<~YAML
      common:
        pg_bin_path: "/usr/lib/postgresql/16/bin"
        tmp_dir: "/tmp"

      storage:
        s3:
          endpoint: "http://playground-storage:9000"
          bucket: "adventureworks"
          region: "us-east-1"
          access_key_id: "Q3AM3UQ867SPQQA43P2F"
          secret_access_key: "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG"

      validate:
      #  resolved_warnings:
      #    - "aa808fb574a1359c6606e464833feceb"

      dump:
        pg_dump_options: # pg_dump option that will be provided
          dbname: "host=playground-db user=postgres password=example dbname=original"
          jobs: 10

        transformation: # List of tables to transform
          - schema: "humanresources" # Table schema
            name: "employee"  # Table name
            transformers: # List of transformers to apply
              - name: "NoiseDate" # name of transformers
                params: # Transformer parameters
                  ratio: "10 year 9 mon 1 day"
                  column: "birthdate" # Column parameter - this transformer affects scheduled_departure column

      restore:
        pg_restore_options: # pg_restore option (you can use the same options as pg_restore has)
          jobs: 10
          dbname: "host=playground-db user=postgres password=example dbname=transformed"
    YAML

    output = shell_output("#{bin}/greenmask --config config.yml list-transformers")
    assert_match "Generate UUID", output
    assert_match "Generates a random word", output
  end
end