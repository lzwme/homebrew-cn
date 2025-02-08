class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https:www.greenmask.io"
  url "https:github.comGreenmaskIOgreenmaskarchiverefstagsv0.2.7.tar.gz"
  sha256 "da71261efb7f6866a28d227430c4b41e0a1a09f0eac6a597ae3800c0299765f3"
  license "Apache-2.0"
  head "https:github.comGreenmaskIOgreenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61f67029c5604be41df6b4263603a71211c47e80c665ba3f6291cfec705e9bcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61f67029c5604be41df6b4263603a71211c47e80c665ba3f6291cfec705e9bcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61f67029c5604be41df6b4263603a71211c47e80c665ba3f6291cfec705e9bcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "37fcb8afdc81e51f98b38d70e37f0544cdb350aefe8174b51ad79cddb97b432c"
    sha256 cellar: :any_skip_relocation, ventura:       "37fcb8afdc81e51f98b38d70e37f0544cdb350aefe8174b51ad79cddb97b432c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99fb31d8b5b1a695ae8fd0391450b96fc9b117fcd191f0c8f8568b1a60bcca39"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgreenmaskiogreenmaskcmdgreenmaskcmd.Version=#{version}
    ]
    system "go", "build", "-tags=viper_bind_struct", *std_go_args(ldflags:), ".cmdgreenmask"

    generate_completions_from_executable(bin"greenmask", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}greenmask -v")

    (testpath"config.yml").write <<~YAML
      common:
        pg_bin_path: "usrlibpostgresql16bin"
        tmp_dir: "tmp"

      storage:
        s3:
          endpoint: "http:playground-storage:9000"
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

    output = shell_output("#{bin}greenmask --config config.yml list-transformers")
    assert_match "Generate UUID", output
    assert_match "Generates a random word", output
  end
end