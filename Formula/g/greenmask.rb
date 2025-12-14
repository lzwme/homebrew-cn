class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://www.greenmask.io/"
  url "https://ghfast.top/https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.15.tar.gz"
  sha256 "d9cc46c66caf3610abe35feda46cb3e341faaf8b7b3503dfc964357da9def21c"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eae56c1c6f824f69e79b2320b970f6a406498be1623734636e03f89723f96987"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eae56c1c6f824f69e79b2320b970f6a406498be1623734636e03f89723f96987"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eae56c1c6f824f69e79b2320b970f6a406498be1623734636e03f89723f96987"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a7d04d6f332279d5827f720cc486861d7f5562f435675fd35d2f4d5e65dc54f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98c27d2cb3401b86fdbc23de1200e7b8999b77acd4b42853c34e8c211669786b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09ee4b113e89694c2007581b625b3866303183be826ef9021174e8d9a806cc08"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/greenmaskio/greenmask/cmd/greenmask/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, tags: "viper_bind_struct"), "./cmd/greenmask"

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